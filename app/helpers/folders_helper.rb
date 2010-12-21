module FoldersHelper
  def breadcrumbs(folder, breadcrumbs = '')
    breadcrumbs = "<span class=\"breadcrumb nowrap\">#{link_to(folder.parent.name, folder.parent)}</span> &raquo; #{breadcrumbs}"
    breadcrumbs = breadcrumbs(folder.parent, breadcrumbs) unless folder.parent == Folder.root
    breadcrumbs.html_safe
  end
end
