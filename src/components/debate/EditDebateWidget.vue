<template>
  <div class="full-width">
  <q-form @submit="postForm" greedy class="q-pa-md bg-grey-4">
    <q-input
     filled
     stack-label
     v-model="data_title"
     @input="handleInput"
      label="Title"
    />
      <q-separator />
    <q-input
     filled
     stack-label
     label="description"
     @input="handleInput"
     title="description"
     v-model="data_description"
     type="textarea"
     autogrow
    />
      <q-separator />
    <q-input
    filled
     stack-label
     @input="handleInput"
     title="avatar_url"
     v-model="data_avatar_url"
    label="Avatar URL"
    type="url"
    />
    <div class="full-width  text-right q-mt-md">
      <q-btn label="SUBMIT" type="submit" color="primary"/>
    </div>
  </q-form>
  </div>
</template>
<script>
export default {
  title: 'EditDebateWidget',
  props: ['title', 'description', 'avatar_url', 'id', 'reload'],
  model: {
    prop: 'title',
    event: 'blur'
  },
  watch: {
    title (newVal) {
      this.data_title = newVal
    },
    description (newVal) {
      this.data_description = newVal
    },
    avatar_url (newVal) {
      this.data_avatar_url = newVal
    }
  },
  data () {
    return {
      data_title: this.title,
      data_description: this.description,
      data_avatar_url: this.avatar_url
    }
  },
  mounted () {
    this.data_title = this.title
    this.$mount()
  },
  methods: {
    handleInput (value) {
      this.$emit('msgChange', value)
    },
    postForm: async function (e) {
      const payload = {
        title: this.data_title,
        description: this.data_description,
        avatar_url: this.data_avatar_url
      }
      const q = `${process.env.api}/debates/${this.id}`
      await this.$axios.patch(q, payload, { headers: { Accept: 'application/json' } })
        .then((res) => {
          this.reload()
          this.$q.notify({
            type: 'positive',
            message: 'Update Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error saving: ' + err
          })
        })
    }
  }
}
</script>
