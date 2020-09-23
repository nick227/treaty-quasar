<template>
  <div class="row full-width">
    <div class="col"></div>
    <q-form class="col col-8">
       <q-input
        class="full-width"
        v-model="title"
        label="Title"
        lazy-rules
        required
      />
      <q-input
      class="full-width"
      v-model="description"
      label="Description"
      lazy-rules
      autogrow
      required
      type="textarea"
    />
    <q-btn @click="postForm" label="SUBMIT" color="primary" class="q-ma-md float-right" />
    </q-form>
    <div class="col"></div>
  </div>
</template>
<script>
export default {
  name: 'AddProvision',
  props: ['id', 'numProvisions', 'reload'],
  data () {
    return {
      title: '',
      description: ''
    }
  },
  methods: {
    postForm: async function (e) {
      const q = `${process.env.api}/treaty-provisions`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        treaty_id: this.id,
        status_id: 1,
        title: this.title,
        description: this.description,
        position: this.numProvisions || 0
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } }).then(() => {
        this.$q.notify({
          type: 'positive',
          message: 'Provision Received'
        })
        this.reload()
        this.title = ''
        this.description = ''
        window.scrollTo(2, document.body.scrollHeight)
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: err
        })
      })
    }
  }
}
</script>
