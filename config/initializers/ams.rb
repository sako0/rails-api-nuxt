# 関連モデルもJSONにincludeする設定
ActiveModelSerializers.config.default_includes = '**'
# JSONの整形を行う
ActiveModelSerializers.config.adapter = :json_api