<template>
  <div class="bg-grey-4">
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
  </div>
</template>
<script>
export default {
  name: 'EditOrganizationWidget',
  props: ['organization', 'reload'],
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
      data_name: this.organization.name,
      data_description: this.organization.description,
      data_avatar_url: this.organization.avatar_url
    }
  },
  mounted () {
    this.$mount()
  },
  methods: {
    handleInput (value) {
      this.$emit('msgChange', value)
    },
    postForm: async function (e) {
      const payload = {
        id: this.organization.id,
        name: this.data_name,
        description: this.data_description,
        avatar_url: this.data_avatar_url
      }
      const q = `${process.env.api}/organizations/${this.organization.id}`
      await this.$axios.patch(q, payload)
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
            message: 'Error updating: ' + err
          })
        })
    }
  }
}

</script>
