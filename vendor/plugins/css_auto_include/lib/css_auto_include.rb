module ActionView
  module Helpers
    module AssetTagHelper
      # Checks for the existence of view related stylesheets and
      # includes them based on current controller and action name.
      # 
      # Supports the following include options
      #   Given: controller_name => "users", action_name => "new"
      # 
      # The following files will be checked for
      #   1. public/stylesheets/views/users.js
      #   2. public/stylesheets/views/users/new.js
      #   3. public/stylesheets/views/users/new-*.js
      #   4. public/stylesheets/views/users/*-new.js
      #   5. public/stylesheets/views/users/*-new-*.js
      # 
      # This allows javascript files to be shared between multiple views
      # an unlimited number of views can be stringed together e.g.
      # new-edit-index.js would be included in the new, edit, and index views
      
      @@cssai_path       = "#{Rails.root}/public/stylesheets/views"
      @@cssai_ext        = '.css'
      @@cssai_url        = 'views'
      @@cssai_delimiter  = '-'
      @@cssai_paths      = []
      
      def css_auto_include_tags
        @@cssai_paths = []
        return unless File.directory? @@cssai_path
        if File.exists?(File.join(@@cssai_path, controller.controller_path + @@cssai_ext))
          @@cssai_paths.push(File.join(@@cssai_url, controller.controller_path))
        end

        search_dir(controller.controller_path, controller.action_name)
        stylesheet_link_tag *@@cssai_paths
      end
      
      private
      def search_dir(cont, action)
        dir = File.join(@@cssai_path, cont)
        return unless File.directory? dir
        Dir.new(dir).each do |file|
          if File.extname(file) == @@cssai_ext
            file.split(@@cssai_delimiter).collect do |part|
              @@cssai_paths.push(File.join(@@cssai_url, cont, file)) if File.basename(part, @@cssai_ext) == action
            end
          end
        end
      end
      
    end
  end
end