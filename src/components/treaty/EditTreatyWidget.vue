<template>
  <div style="width:100%">
  <q-form @submit="postForm" greedy class="self-center q-pa-md bg-grey-4">
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
     name="avatarUrl"
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
  name: 'EditTreatyWidget',
  props: ['name', 'description', 'avatarUrl', 'id', 'reload'],
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
    avatarUrl (newVal) {
      this.data_avatar_url = newVal
    }
  },
  data () {
    return {
      data_name: this.name,
      data_description: this.description,
      data_avatar_url: this.avatarUrl
    }
  },
  mounted () {
    this.data_name = this.name
    this.$mount()
  },
  methods: {
    handleInput (value) {
      this.$emit('msgChange', value)
    },
    postForm: async function (e) {
      const payload = {
        name: this.data_name,
        description: this.data_description,
        avatar_url: this.data_avatar_url,
        id: this.id
      }
      const q = `${process.env.api}/treaties/${this.id}`
      console.log(q)
      console.log(payload)
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
            message: 'Error updating Treaty: ' + err
          })
        })
    }
  }
}
</script>
