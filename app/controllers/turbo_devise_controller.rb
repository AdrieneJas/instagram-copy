class TurboDeviseController < ApplicationController
    class Responder < ActionController::Responder
        def to_tutbo_stream
            controller.render(options.merge(formats: :html))
        rescue ActionView::MissingTemplate => error
            if get?
                raise error
            elsif has_error? && default_action
                render rendering_options.merge(formats: :html, status: :unprocessable_entity)
            else
                redirect to navigation_location
            end
        end
    end

    self.responder = Responder
    respond_to :html, :turbo_stream
end


class TurboFailureApp < Devise::TurboFailureApp
    def respond
        if request_format == :turbo_stream
            redirect
        else
            super
        end
    end

    def skip_format?
        %w(html turbo_stream */*).include? request_format.to_s
    end
end
