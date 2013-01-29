module Capybara
  class Persona
    attr_reader :session

    def initialize(session)
      @session = session
    end

    def has_visible_window?
      persona_window
    end

    def set_email(email)
      within_persona_window do
        session.fill_in 'authentication_email', :with => email
        by_classes('button.start.addressInfo').click
      end
    end

    def set_password(password)
      within_persona_window do
        session.fill_in 'authentication_password', :with => password
      end
    end

    def submit_credentials(act_as_computer_owner = false)
      within_persona_window do
        by_classes('button.returning').click

        if session.has_button?('this_is_not_my_computer')
          if act_as_computer_owner
            session.click_button 'this_is_not_my_computer'
          else
            session.click_button 'this_is_my_computer'
          end
        end

        wait_for_completion
      end
    end

    def wait_for_completion
      Capybara.default_wait_time.times do
        find_persona_window.nil?
        sleep 1
      end
    end

    def state
      within_persona_window do
        if session.has_content?('Please create a password')
          :create_password
        end
      end
    end

    def within_persona_window
      session.within_window(persona_window) { yield }
    end

    def persona_window
      @persona_window ||= find_persona_window.tap do |w|
        raise 'Unable to find Persona window' unless w
      end
    end
    
    def by_classes(classes)
      within_persona_window { session.first(classes) }
    end

    def find_persona_window
      handles = session.driver.browser.window_handles

      window = handles.detect do |h|
        begin
          session.within_window(h) do
            session.has_xpath?('//title', :text => /Mozilla Persona/)
          end
        rescue ::Selenium::WebDriver::Error::NoSuchWindowError, Capybara::ElementNotFound
          # OK, the window might have closed before we got to investigate it,
          # just check out the next one.
        end
      end
    end
  end
end