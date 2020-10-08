<template>
  <div></div>
</template>
<script>
import { date } from 'quasar'
export default {
  name: 'TextToolsMixin',
  methods: {
    timeSince: function (d) {
      const secsDiff = Math.max(date.getDateDiff(new Date(), d, 'seconds'), 0)
      if (secsDiff < 60) {
        return secsDiff + ' seconds ago'
      }
      if (secsDiff < 60 * 60) {
        return date.getDateDiff(new Date(), d, 'minutes') + ' minutes ago'
      }
      if (secsDiff < 60 * 60 * 12) {
        return date.getDateDiff(new Date(), d, 'hours') + ' hours ago'
      }
      return date.getDateDiff(new Date(), d, 'days') + ' days ago'
    }
  }
}
</script>
