# 関連モデルもJSONにincludeする設定
ActiveModelSerializers.config.default_includes = '**'
# JSONの整形を行う
ActiveModelSerializers.config.adapter = :json_api
# "_"が"-"に変更されてしまうため、以下を記入
ActiveModelSerializers.config.key_transform = :underscore