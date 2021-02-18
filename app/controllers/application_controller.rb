class ApplicationController < ActionController::API

  # ログインしているか確認する
  def logged_in?
    !current_user.nil?
  end
end
