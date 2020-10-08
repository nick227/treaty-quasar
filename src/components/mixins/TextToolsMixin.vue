<template>
  <div></div>
</template>
<script>
export default {
  name: 'TextToolsMixin',
  methods: {
    checkStr: function (str) {
      let res = this.stripTags(str)
      res = this.ytCheck(res)
      res = this.imageUrlCheck(res)
      res = this.unsplashUrlCheck(res)
      res = this.linkCheck(res)
      return res
    },
    ytCheck: function (str) {
      const ytMatch = str.match(/(http:|https:)?(\/\/)?(www\.)?(youtube.com|youtu.be)\/(watch|embed)?(\?v=|\/)?(\S+)?/)
      const ytEmbedHtml = '<iframe type="text/html" width="480" height="320" src="https://www.youtube.com/embed/embed_code_target" frameborder="0"></iframe>'
      return ytMatch ? str.replace(ytMatch[0], function (a, b) { return ytEmbedHtml.replace('embed_code_target', ytMatch[7].split('&')[0]) }) : str
    },
    stripTags: function (str) {
      return str.replaceAll('<script>', '')
    },
    imageUrlCheck: function (str) {
      const re = /(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)/gi
      const m = str.replace(re, function (match) { return '<img src="' + match + '" style="max-width:100%;" />' })
      return m
    },
    unsplashUrlCheck: function (str) {
      const re = /(https?:\/\/(.+?\.)?images.unsplash\.com(\/[A-Za-z0-9\-._~:?#[\]@!$&'()*+,;=]*)?)/g
      const m = str.replace(re, function (match) { return '<img src="' + match + '" style="max-width:100%;" />' })
      return m
    },
    linkCheck: function (str) {
      function containsExclude (needle) {
        const excludeList = ['youtube', 'youtu', 'images.unsplash', '.jpg', '.jpeg', '.gif', '.png', '.webp']
        for (let i = 0; i < excludeList.length; i++) {
          if (needle.indexOf(excludeList[i]) > -1) {
            return true
          }
        }
        return false
      }
      const re = /https?:\/\/(www\.)?[-a-zA-Z0-9@:%._+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_+.~#?&//=]*)(?!png|gif|jpg)/g
      const m = str.replace(re, function (match) { return containsExclude(match) ? match : '<a target="_blank" href="' + match + '" />' + match + '</a>' })
      return m
    }
  }
}
</script>
