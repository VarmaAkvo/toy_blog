# 指定 I18n 库搜索翻译文件的路径
I18n.load_path += Dir[Rails.root.join('lib', 'locale', '*.{rb,yml}')]

# 应用可用的区域设置白名单
I18n.available_locales = [:en, :cn]

# 修改默认区域设置（默认是 :en）
I18n.default_locale = :cn
