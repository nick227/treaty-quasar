<template>
<div class="row" style="width:60px;">
  <div class="col col-6 text-center">
    <div>
      <q-icon @click="like" name="thumb_up" v-ripple color="blue" :class="!readonly ? 'cursor-pointer' : ''" />
    </div>
    <div>
      <span class="text-weight-bolder">{{ numLikes }}</span>
    </div>
  </div>
  <div class="col col-6 text-center">
    <div ripple>
      <q-icon @click="dislike" name="thumb_down" v-ripple color="red" :class="!readonly ? 'cursor-pointer' : ''" />
    </div>
    <div>
      <span class="text-weight-bolder">{{ numDislikes }}</span>
    </div>
  </div>
</div>
</template>
<script>
export default {
  name: 'LikeButtons',
  props: ['entityType', 'entityId', 'organizationId', 'organizationName', 'readonly'],
  data () {
    return {
      numLikes: 0,
      numDislikes: 0,
      org_a: {},
      org_b: {}
    }
  },
  methods: {
    like: async function () {
      this.update(1)
    },
    dislike: function () {
      this.update(0)
    },
    update: async function (val) {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      if (!this.$errorHandler.organizationCheck(this.organizationId)) { return false }
      if (this.readonly) {
        this.$q.notify({
          type: 'negative',
          message: 'Wrong Organization'
        })
        return false
      }
      const q = `${process.env.api}/${this.entityType}-likes`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        organization_id: this.organizationId,
        liked: val
      }
      payload[this.entityType + '_id'] = this.entityId
      console.log(q)
      console.log(payload)
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.getLikes()
    },
    getLikes: async function () {
      const q = `${process.env.api}/${this.entityType}-likes?filter[where][and][0][${this.entityType}_id]=${this.entityId}&filter[where][and][1][organization_id]=${this.organizationId}`
      const likes = await this.$axios.get(q)
      this.numLikes = 0
      this.numDislikes = 0
      for (let i = 0; i < likes.data.length; i++) {
        if (likes.data[i].liked === 1) {
          this.numLikes = this.numLikes + 1
        } if (likes.data[i].liked === 0) {
          this.numDislikes = this.numDislikes + 1
        }
      }
    }
  },
  mounted () {
    this.getLikes()
  }
}
</script>
