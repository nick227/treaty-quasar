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
     label="Location"
     @input="handleInput"
     v-model="data_location"
     name="location"
     autogrow
    />
      <q-separator />
    <q-input
     filled
     stack-label
     label="Biography"
     @input="handleInput"
     name="biography"
     v-model="data_biography"
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
      <q-separator />
    <q-input
    filled
     stack-label
     @input="handleInput"
     name="profile_background_url"
     v-model="data_profile_background_url"
    label="Profile Background Image"
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
  name: 'EditProfileWidget',
  props: ['name', 'biography', 'avatar_url', 'location', 'profile_background_url', 'uid', 'reload'],
  model: {
    prop: 'name',
    event: 'blur'
  },
  watch: {
    name (newVal) {
      this.data_name = newVal
    },
    biography (newVal) {
      this.data_biography = newVal
    },
    avatar_url (newVal) {
      this.data_avatar_url = newVal
    },
    location (newVal) {
      this.data_location = newVal
    },
    profile_background_url (newVal) {
      this.data_profile_background_url = newVal
    }
  },
  data () {
    return {
      data_name: this.name,
      data_description: this.description,
      data_avatar_url: this.avatar_url,
      data_location: this.location,
      data_biography: this.biography,
      data_profile_background_url: this.profile_background_url
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
        id: this.uid,
        name: this.data_name,
        location: this.data_location,
        biography: this.data_biography,
        avatar_url: this.data_avatar_url,
        profile_background_url: this.data_profile_background_url
      }
      const q = `${process.env.api}/users/${this.uid}`
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
            message: err
          })
        })
    }
  }
}

</script>
