<template>
  <div class="q-pa-md bg-grey-2">
      <div class="q-mb-md row cursor-pointer" clickable @click="share('fb')"><q-icon name="ion-logo-facebook" size="2em" class="q-mr-md q-mb-sm" />Share to Facebook</div>
      <div class="q-mb-md row cursor-pointer" clickable @click="share('tw')"><q-icon name="ion-logo-twitter" size="2em" class="q-mr-md" />Share to Twitter</div>
      <div class="q-mb-md row cursor-pointer" clickable @click="share('rd')"><q-icon name="ion-logo-reddit" size="2em" class="q-mr-md" />Share to Reddit</div>
  </div>
</template>
<script>
export default {
  props: ['entityId', 'entityType', 'title'],
  name: 'ShareWidget',
  components: {},
  data () {
    return {}
  },
  methods: {
    share: function (key) {
      const title = this.title
      const actions = {
        fb: function () {
          const url = 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(window.location.href)
          window.open(url, '_blank', 'height=400,width=480')
        },
        tw: function () {
          const url = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(title + ' ' + window.location.href)
          window.open(url, '_blank', 'height=400,width=480')
        },
        rd: function () {
          const url = 'http://www.reddit.com/submit?url=' + encodeURIComponent(window.location.href) + '&title=' + encodeURIComponent(title)
          window.open(url, '_blank', 'height=' + screen.availHeight * 0.7 + ',width=' + screen.width * 0.9)
        }
      }
      actions[key]()
    }
  },
  mounted () {}
}
</script>
