# frozen_string_literal: true

# name: discourse-m3u8-onebox
# about: Enables Onebox support for m3u8 video links
# version: 0.1
# authors: Your Name

enabled_site_setting :discourse_m3u8_onebox_enabled

after_initialize do
  module M3u8Onebox
    class Engine < ::Onebox::Engine::VideoOnebox
      # 添加对 m3u8 文件的匹配
      matches_regexp(%r{^(https?:)?//.*\.(mov|mp4|webm|ogv|m3u8)(\?.*)?$}i)

      def to_html
        # 判断是否是 m3u8 文件，如果是，则使用适用于 Video.js 的 HTML 模板
        if @url.match?(%r{\.m3u8$})
          # 获取时间戳，并添加一段八位随机数
          random_id = "#{Time.now.to_i}#{rand(100_000_000)}"
          <<-HTML
            <div class="onebox video-onebox videoWrap">
              <video id='#{random_id}' class="video-js vjs-default-skin vjs-16-9" controls preload="auto" width="100%" data-setup='{"fluid": true}'>
                <source src="#{@url}" type="application/x-mpegURL">
              </video>
            </div>
          HTML
        else
          # 原有处理非 m3u8 文件的代码保持不变
          super
        end
      end
    end
  end

  Onebox::Engine::BaseOnebox.add_engine(M3u8Onebox::Engine)
end
