class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    protect_from_forgery with: :exception

    include Pundit

    # Обработка ошибок Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def devise_mapping
        Devise.mappings[:user]
    end

    private

    def user_not_authorized
        flash[:alert] = "У вас нет прав для выполнения этого действия."
        redirect_to(request.referrer || root_path)
    end

    protected

    def configure_permitted_parameters
        added_attrs = [:full_name]
        devise_parameter_sanitizer.permit(:sign_up, keys: added_attrs)
        devise_parameter_sanitizer.permit(:account_update, keys: added_attrs)
    end
end
