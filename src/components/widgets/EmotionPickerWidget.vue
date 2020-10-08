<template>
  <div>
      <q-chip :disable="emotion.important.disabled" :selected.sync="emotion.important.val" @click="updateEmotion('important')" color="primary" square text-color="white">
        {{ emotion.important.num }} Important
      </q-chip>
      <q-chip :disable="emotion.interesting.disabled" :selected.sync="emotion.interesting.val" @click="updateEmotion('interesting')" color="teal" square text-color="white">
        {{ emotion.interesting.num }} Interesting
      </q-chip>
      <q-chip :disable="emotion.fake.disabled" :selected.sync="emotion.fake.val" @click="updateEmotion('fake')" color="orange" square text-color="white">
        {{ emotion.fake.num }} Fake
      </q-chip>
      <q-chip :disable="emotion.terrible.disabled" :selected.sync="emotion.terrible.val" @click="updateEmotion('terrible')" color="red" square text-color="white">
        {{ emotion.terrible.num }} Terrible
      </q-chip>
  </div>
</template>
<script>
export default {
  name: 'EmotionPickerWidget',
  components: {},
  props: ['emotions', 'activityId'],
  data () {
    return {
      emotion: {
        important: { num: 0, val: false, id: null, disabled: false },
        interesting: { num: 0, val: false, id: null, disabled: false },
        fake: { num: 0, val: false, id: null, disabled: false },
        terrible: { num: 0, val: false, id: null, disabled: false }
      }
    }
  },
  methods: {
    updateEmotion: function (e) {
      this.emotion[e].disabled = true
      if (this.emotion[e].val) {
        this.addEmotion(e)
      } else {
        this.removeEmotion(e)
      }
    },
    addEmotion: async function (e) {
      const q = `${process.env.api}/activity-emotions`
      const payload = {
        name: e,
        activity_id: this.activityId,
        creator_user_id: this.$store.state.user.uid
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then((res) => {
        this.emotion[e].id = res.data.id
        this.emotion[e].num++
        this.emotion[e].disabled = false
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: 'Error saving emotion: ' + err
        })
      })
    },
    removeEmotion: async function (e) {
      const q = `${process.env.api}/activity-emotions/${this.emotion[e].id}`
      await this.$axios.delete(q).then(() => {
        this.emotion[e].num--
        this.emotion[e].disabled = false
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: 'Error saving emotion: ' + err
        })
      })
    }
  },
  mounted () {
    if (this.emotions) {
      const self = this
      this.emotions.forEach(function (obj) {
        if (obj.creator_user_id === self.$store.state.user.uid) {
          self.emotion[obj.name].val = true
          self.emotion[obj.name].id = obj.id
        }
        self.emotion[obj.name].num = self.emotion[obj.name].num + 1
      })
    }
  }
}
</script>
