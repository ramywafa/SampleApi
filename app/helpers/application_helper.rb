module ApplicationHelper
  def page_header(header_text)
    content_tag(:div, class: 'row') do
      content_tag(:div, class: 'col-lg-12') do
        content_tag(:h1, class: 'page-header') do
          header_text
        end
      end
    end.html_safe
  end

  def dashboard_statistics_viewer(columns, panel_color, text, icon, count)
    content_tag(:div, class: columns) do
      content_tag(:div, class: ['panel', panel_color]) do
        content_tag(:div, class: 'panel-heading') do
          content_tag(:div, class: 'row') do
            content_tag(:div, class: 'col-xs-3') do
              content_tag(:i, class: "fa fa-#{icon} fa-5x") do
              end.html_safe
            end.html_safe.concat(
            content_tag(:div, class: 'col-xs-9 text-right') do
              content_tag(:div, class: 'huge') do
                count.to_s
              end.html_safe.concat(
              content_tag(:div) do
                text
              end)
            end)
          end
        end
      end
    end.html_safe
  end
end
