module FoldersHelper
  def breadcrumbs(folder, breadcrumbs = '')
    breadcrumbs = "<span class=\"breadcrumb nowrap\">#{link_to(folder.parent.name, folder.parent)}</span> &raquo; #{breadcrumbs}"
    breadcrumbs = breadcrumbs(folder.parent, breadcrumbs) unless folder.parent == Folder.root
    breadcrumbs.html_safe
  end

  def file_icon(extension)
    if FileTest.exists?("#{Rails.root}/public/images/fileicons/#{extension}.png")
      "fileicons/#{extension}.png"
    else
      'file.png'
    end
  end
end

