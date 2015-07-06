module Phase9
  class Route < Phase6::Route
    def initialize(pattern, http_method, controller_class, action_name)
      super
      add_route_helpers
    end

    def add_route_helpers
      case action_name
      when :create, :index
        name = "#{class_name_plural}"
        add_path_method(name, "/#{name}")
      when :show, :update, :destroy
        name = "#{class_name_singular}"
        add_path_method(name, "/#{class_name_plural}/:id")
      when :edit
        name = "edit_#{class_name_singular}"
        add_path_method(name, "/#{class_name_plural}/:id/edit")
      when :new
        name = "new_#{class_name_singular}"
        add_path_method(name, "/#{class_name_plural}/new")
    end

    def class_name
      controller_class.to_s.underscore.gsub("_controller", "")
    end

    def class_name_singular
      class_name.singularize
    end

    def class_name_plural
      class_name.pluralize
    end

    def add_path_method(name, path)
     path_name = "#{ name }_path"
     puts "#{ path_name } #=> #{ path }"

     RouteHelpers.send(:define_method, path_name) do |*args|
       id = args.first.to_s
       if path.include?(':id') && !id.nil?
         path.gsub!(':id', id)
       end
       path
     end
   end
  end
  
  class Router < Phase6::Router
   def add_route(pattern, method, controller_class, action_name)
     @routes << Route.new(
       pattern,
       method,
       controller_class,
       action_name
     )
   end
 end
end
