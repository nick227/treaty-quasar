<template>
  <div class="dialog-width">
  <q-form @submit="postForm" greedy class="q-pa-md bg-grey-4">
    <q-input
     filled
     stack-label
     v-model="data_name"
     @input="handleInput"
      label="Name"
    />
      <q-separator />
    <q-input
     filled
     stack-label
     label="description"
     @input="handleInput"
     name="description"
     v-model="data_description"
     type="textarea"
     autogrow
    />
      <q-separator />
    <q-input
    filled
     stack-label
     @input="handleInput"
     name="avatar_url"
     v-model="data_avatar_url"
    label="Avatar URL"
    type="url"
    />
    <div class="full-width  text-right q-mt-md">
      <q-btn label="SUBMIT" type="submit" color="primary"/>
    </div>
  </q-form>
  <q-dialog v-model="confirm" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="check" color="primary" text-color="white" />
          <span class="q-ml-sm">Permanently delete this conflict?</span>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat label="DELETE FOREVER" @click="deleteConflict" color="primary" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>
<script>
export default {
  name: 'EditConflictWidget',
  props: ['name', 'description', 'avatar_url', 'id', 'status', 'reload'],
  model: {
    prop: 'name',
    event: 'blur'
  },
  watch: {
    name (newVal) {
      this.data_name = newVal
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
      data_name: this.name,
      data_description: this.description,
      data_avatar_url: this.avatar_url,
      confirm: false
    }
  },
  mounted () {
    this.data_name = this.name
    this.$mount()
  },
  methods: {
    deleteConflict: async function () {
      const q = `${process.env.api}/conflicts/${this.id}`
      await this.$axios.delete(q)
        .then((res) => {
          this.confirm = false
          this.pageReload()
          this.$q.notify({
            type: 'positive',
            message: 'Delete Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error deleting: ' + err
          })
        })
    },
    handleInput (value) {
      this.$emit('msgChange', value)
    },
    postForm: async function (e) {
      if (!this.$errorHandler.loggedInCheck()) { return false }
      const payload = {
        name: this.data_name,
        description: this.data_description,
        avatar_url: this.data_avatar_url
      }
      const q = `${process.env.api}/conflicts/${this.id}`
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
