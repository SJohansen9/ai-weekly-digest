#!/usr/bin/env ruby
# encoding: utf-8
# Converts digest Markdown to styled HTML, then prints to PDF via Chrome headless.

require 'cgi'
require 'fileutils'
require 'open3'

CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'

def esc(text)
  CGI.escapeHTML(text.to_s)
end

def inline_md(text)
  esc(text)
    .gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')
    .gsub(/\*(.+?)\*/, '<em>\1</em>')
end

def signal_class(signal)
  return 'signal-green' if signal.include?('🟢')
  return 'signal-red' if signal.include?('🔴')
  'signal-amber'
end

def markdown_to_html(md)
  lines = md.each_line.map(&:rstrip)
  parts = []
  in_table = false
  in_story = false
  meta_lines = []

  flush_table = lambda do
    return unless in_table
    parts << '</tbody></table></div>'
    in_table = false
  end

  close_story = lambda do
    return unless in_story
    flush_table.call
    parts << '</article>'
    in_story = false
  end

  lines.each do |line|
    if in_table && !line.start_with?('|')
      flush_table.call
    end

    case line
    when /^---+\s*$/
      close_story.call
      parts << '<hr class="rule"/>'
    when /^# (.+)/
      close_story.call
      parts << "<h1 class=\"doc-title\">#{inline_md($1)}</h1>"
    when /^## (.+)/
      close_story.call
      parts << "<h2 class=\"section\">#{inline_md($1)}</h2>"
    when /^### (.+)/
      close_story.call
      parts << '<article class="story">'
      parts << "<h3 class=\"headline\">#{inline_md($1)}</h3>"
      in_story = true
    when /^\*(.+)\*$/
      parts << "<p class=\"source\">#{inline_md($1)}</p>"
    when /^\|(.+)\|$/
      next if line.include?('---')
      cells = line.split('|').map(&:strip).reject(&:empty?)
      unless in_table
        parts << '<div class="table-wrap"><table><thead><tr>'
        cells.each { |c| parts << "<th>#{inline_md(c)}</th>" }
        parts << '</tr></thead><tbody>'
        in_table = true
      else
        cls = cells.last.to_s.match?(/🟢|🔴|🟡/) ? signal_class(cells.last) : ''
        parts << '<tr>'
        cells.each_with_index do |c, i|
          if i == cells.length - 1 && !cls.empty?
            parts << "<td class=\"#{cls}\">#{inline_md(c)}</td>"
          else
            parts << "<td>#{inline_md(c)}</td>"
          end
        end
        parts << '</tr>'
      end
    when /^\*\*(Period|Generated)\*\*\s*:?\s*(.*)$/
      meta_lines << "<span><strong>#{esc($1)}:</strong> #{inline_md($2.sub(/\A:\s*/, ''))}</span>"
    when /^\*\*(.+?)\*\*\s*(.+)$/
      label = esc($1)
      rest = inline_md($2.sub(/\A:\s*/, ''))
      parts << "<p class=\"label-block\"><strong>#{label}:</strong> #{rest}</p>"
    when /^\*\*(Legend)\*\*\s*:?\s*(.*)$/
      parts << "<p class=\"legend\">#{inline_md($2.sub(/\A:\s*/, ''))}</p>"
    when /^\s*$/
      next
    else
      parts << "<p>#{inline_md(line)}</p>"
    end
  end

  close_story.call
  meta_html = meta_lines.empty? ? '' : "<p class=\"meta\">#{meta_lines.join(' &nbsp;|&nbsp; ')}</p>"

  body = parts.join("\n")
  body = body.sub(/(<h1 class="doc-title">.*?<\/h1>)/m, "\\1\n#{meta_html}")

  <<~HTML
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="utf-8"/>
      <title>AI Weekly Digest</title>
      <style>
        @page { size: A4; margin: 16mm 14mm 18mm 14mm; }
        * { box-sizing: border-box; }
        body {
          font-family: -apple-system, BlinkMacSystemFont, "Helvetica Neue", Helvetica, Arial, sans-serif;
          font-size: 10.5pt;
          line-height: 1.55;
          color: #1a1a1a;
          max-width: 700px;
          margin: 0 auto;
        }
        .doc-title {
          font-size: 21pt;
          font-weight: 700;
          letter-spacing: -0.02em;
          margin: 0 0 6px;
          color: #0f172a;
          border-bottom: 3px solid #2563eb;
          padding-bottom: 8px;
        }
        .meta { color: #475569; font-size: 9.5pt; margin: 0 0 18px; }
        .section {
          font-size: 13pt;
          font-weight: 700;
          color: #1e40af;
          margin: 24px 0 12px;
          padding-bottom: 4px;
          border-bottom: 1px solid #cbd5e1;
          page-break-after: avoid;
        }
        article.story {
          margin: 0 0 18px;
          padding: 14px 16px;
          border: 1px solid #dbeafe;
          border-left: 4px solid #2563eb;
          border-radius: 6px;
          background: #f8fafc;
          page-break-inside: avoid;
        }
        .headline {
          font-size: 11.5pt;
          font-weight: 700;
          margin: 0 0 4px;
          color: #0f172a;
          line-height: 1.35;
        }
        .source {
          font-size: 8.5pt;
          color: #64748b;
          margin: 0 0 10px;
          font-style: italic;
        }
        .table-wrap { margin: 8px 0 10px; }
        table { width: 100%; border-collapse: collapse; font-size: 9pt; }
        th {
          background: #1e3a8a;
          color: #fff;
          text-align: left;
          padding: 7px 9px;
          font-weight: 600;
        }
        td {
          border: 1px solid #e2e8f0;
          padding: 7px 9px;
          vertical-align: top;
          background: #fff;
        }
        td:first-child { font-weight: 600; width: 24%; color: #334155; background: #f1f5f9; }
        .label-block { margin: 8px 0 0; font-size: 9.5pt; }
        .label-block strong { color: #1e40af; display: inline; }
        .legend { font-size: 9pt; color: #64748b; margin-top: 8px; }
        hr.rule { border: none; border-top: 1px dashed #cbd5e1; margin: 14px 0; }
        .signal-green { color: #15803d; font-weight: 700; text-align: center; }
        .signal-amber { color: #b45309; font-weight: 700; text-align: center; }
        .signal-red { color: #b91c1c; font-weight: 700; text-align: center; }
        p { margin: 0 0 6px; }
      </style>
    </head>
    <body>
    #{body}
    </body>
    </html>
  HTML
end

def html_to_pdf(html_path, pdf_path)
  unless File.exist?(CHROME)
    raise "Google Chrome not found at #{CHROME}"
  end

  url = "file://#{File.expand_path(html_path)}"
  cmd = [
    CHROME,
    '--headless=new',
    '--disable-gpu',
    '--no-pdf-header-footer',
    '--print-to-pdf-no-header',
    "--print-to-pdf=#{File.expand_path(pdf_path)}",
    url
  ]

  stdout, stderr, status = Open3.capture3(*cmd)
  unless status.success? && File.exist?(pdf_path) && File.size(pdf_path) > 1000
    raise "Chrome PDF failed: #{stderr} #{stdout}"
  end
  pdf_path
end

if ARGV.length < 2
  warn 'Usage: markdown_to_pdf.rb <input.md> <output.pdf>'
  exit 1
end

input  = ARGV[0]
output = ARGV[1]
html   = output.sub(/\.pdf\z/i, '.html')
html   = File.join(File.dirname(output), File.basename(html)) if output.include?('/Desktop/')
html_dir = File.dirname(File.expand_path(html))
FileUtils.mkdir_p(html_dir)

md = File.read(input, encoding: 'UTF-8')
File.write(html, markdown_to_html(md), encoding: 'UTF-8')
html_to_pdf(html, output)

size_kb = (File.size(output) / 1024.0).round(1)
puts output
puts "PDF size: #{size_kb} KB"
