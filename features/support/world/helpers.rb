module World
  module AjaxHelpers

    def define_bind
      page.execute_script('Function.prototype.bind||(Function.prototype.bind=function(t){if("function"!=typeof this)throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");var o=Array.prototype.slice.call(arguments,1),n=this,r=function(){},i=function(){return n.apply(this instanceof r&&t?this:t,o.concat(Array.prototype.slice.call(arguments)))};return r.prototype=this.prototype,i.prototype=new r,i});')
    end

    def wait_for_ajax_complete
      Timeout.timeout(Capybara.default_wait_time) do
        loop until page.evaluate_script('$.active').zero?
      end
    end

  end
end

World(World::AjaxHelpers)
