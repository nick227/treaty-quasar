<template>
<div class="row full-width">
  <div class="col col-6 text-center">
    <div @click="like">
      <q-icon name="thumb_up_alt" v-ripple color="blue" class="cursor-pointer" />
    </div>
    <div>
      <span class="text-weight-bolder">{{ numLikes }}</span>
    </div>
  </div>
  <div class="col col-6 text-center">
    <div @click="dislike" ripple>
      <q-icon name="thumb_down_alt" v-ripple color="red" class="cursor-pointer" />
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
  props: {
    entityType: String,
    entityId: Number,
    organizationId: Number,
    organizationName: String,
    numLikes: {
      type: Number,
      default: 0
    },
    numDislikes: {
      type: Number,
      default: 0
    }
  },
  methods: {
    like: async function () {
      const q = `http://localhost:3000/${this.entityType}-like`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        liked: 1
      }
      payload[this.entityType + '_id'] = this.entityId
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.getLikes()
    },
    dislike: function () {
    },
    getLikes: function () {
      console.log('ij')
    }
  },
  mounted () {}
}
</script>
