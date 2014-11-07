module World
  module AjaxHelpers

    # Defines js undefined 'bind' method which causes js tests to fail
    def define_bind
      page.execute_script('Function.prototype.bind||(Function.prototype.bind=function(t){if("function"!=typeof this)throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");var o=Array.prototype.slice.call(arguments,1),n=this,r=function(){},i=function(){return n.apply(this instanceof r&&t?this:t,o.concat(Array.prototype.slice.call(arguments)))};return r.prototype=this.prototype,i.prototype=new r,i});')
    end

    # Waits for every queued ajax to finish.
    def wait_for_ajax_complete
      wait_for_page_load
      wait_for_ajax
    end

    # Waits for all the dough components to be loaded
    def wait_for_page_load
      find('body[data-dough-component-loader-all-loaded="yes"]')
    end

    # Waits for all ajax calls
    def wait_for_ajax
      Timeout.timeout(Capybara.default_wait_time) do
        loop until page.evaluate_script('jQuery.active').zero?
      end
    end

  end
end

World(World::AjaxHelpers)
