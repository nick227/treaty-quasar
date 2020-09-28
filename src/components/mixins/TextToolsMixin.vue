<template>
  <div></div>
</template>
<script>
export default {
  name: 'TextToolsMixin',
  methods: {
    checkStr: function (str) {
      let res = this.ytCheck(str)
      res = this.stripTags(res)
      return res
    },
    ytCheck: function (str) {
      const ytMatch = str.match(/(http:|https:)?(\/\/)?(www\.)?(youtube.com|youtu.be)\/(watch|embed)?(\?v=|\/)?(\S+)?/)
      const ytEmbedHtml = '<iframe type="text/html" width="480" height="320" src="http://www.youtube.com/embed/embed_code_target" frameborder="0"></iframe>'
      return ytMatch ? str.replace(ytMatch[0], function (a, b) { return ytEmbedHtml.replace('embed_code_target', ytMatch[7].split('&')[0]) }) : str
    },
    stripTags: function (str) {
      return str.replaceAll('<script>', '')
    }
  }
}
</script>
