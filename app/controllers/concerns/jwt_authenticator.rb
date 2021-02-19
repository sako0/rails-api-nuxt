module JwtAuthenticator
  require "jwt"

  SECRET_KEY = Rails.application.secrets.secret_key_base
  # 参考https://qiita.com/sagahi/items/755782874695b8ceff20
  # ヘッダーの認証トークンを復号化してユーザー認証を行う
  def jwt_authenticate
    logger.error("認証情報が不足しています。") if request.headers['Authorization'].blank?
    # 下記のようにヘッダーに設定されているとして、トークンをヘッダーから取得する。
    # headers['Authorization'] = "Bearer XXXXX..."
    request.headers.sort.map { |k, v| logger.error "#{k}:#{v}" }
    encoded_token = request.headers['Authorization'].split('Bearer ').last
    # トークンを復号化する(トークンが復号できない場合、有効期限切れの場合はここで例外が発生します。)
    payload = decode(encoded_token)
    # Payloadから取得したユーザーIDでログインしているユーザー情報を取得
    @current_user = User.find_by(id: payload["user_id"])
    logger.error("認証できません。") if @current_user.blank?
    @current_user
  end

  # 暗号化処理
  def encode(user_id)
    expires_in = 1.month.from_now.to_i # 再ログインを必要とするまでの期間を１ヶ月とした場合
    preload = { user_id: user_id, exp: expires_in }
    JWT.encode(preload, SECRET_KEY, 'HS256')
  end

  # 復号化処理
  def decode(encoded_token)
    decoded_dwt = JWT.decode(encoded_token, SECRET_KEY, true, algorithm: 'HS256')
    decoded_dwt.first
  end

end