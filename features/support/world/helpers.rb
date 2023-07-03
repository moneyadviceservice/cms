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
      if Capybara.current_driver == :chrome_headless
        find('body[data-dough-component-loader-all-loaded="yes"]')
      else
        sleep(0.1)
      end
    end

    def wait_for_editor
      # Wait until we see the editor's contente ditable box
      10.times do
        sleep 1

        # Wait an extra second after we see the editor element,
        # it's not ready as soon as we see it.
        sleep 1 && break if edit_page.editor_default.present?
      end
    end

    # Waits for all ajax calls
    def wait_for_ajax
      if Capybara.current_driver == :chrome_headless
        Timeout.timeout(Capybara.default_max_wait_time) do
          loop until page.evaluate_script('jQuery.active').zero?
        end
      else
        sleep(0.1)
      end
    end
  end
end

World(World::AjaxHelpers)
