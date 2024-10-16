import { withPluginApi } from "discourse/lib/plugin-api";

export default {
  name: "extend-video-onebox",
  initialize(container) {
    withPluginApi("0.8.7", (api) => {
      api.modifyClass("component:onebox", {
        didInsertElement() {
          this._super(...arguments);
          // 在此处添加 Video.js 初始化代码
          const videoElements = this.element.querySelectorAll('.video-js');
          videoElements.forEach((videoElement) => {
            const player = videojs(videoElement); // 将 DOM 元素传递给 videojs()
            player.ready(function() {
              console.log("Player is ready!");
            });
          });
        },
      });
    });
  },
};
