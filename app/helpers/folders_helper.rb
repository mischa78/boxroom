module FoldersHelper

  def breadcrumbs(folder, breadcrumbs = '')
    breadcrumbs = "<li>#{link_to(folder.parent.name, folder.parent)}</li> #{breadcrumbs}"
    breadcrumbs = breadcrumbs(folder.parent, breadcrumbs) unless folder.parent == Folder.root
    breadcrumbs.html_safe
  end

  def file_icon(file)
    mapping = {
      # Images
      'image' => 'file-image-o',
      # Audio
      'audio' => 'file-audio-o',
      # Video
      'video' => 'file-video-o',
      # Documents
      'application/pdf' => 'file-pdf-o',
      'text/plain' => 'file-text-o',
      'text/html' => 'file-code-o',
      'application/json' => 'file-code-o',
      # Archives
      'application/gzip' => 'file-archive-o',
      'application/zip' => 'file-archive-o',
      # Misc
      'application/octet-stream' => 'file-o',
    }

    return fa_icon(mapping[file.attachment_content_type] || "file-o").html_safe
  end
end
