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
     name="avatarUrl"
     v-model="data_avatar_url"
    label="Avatar URL"
    type="url"
    />
    <div>
      <p class="text-grey-8 q-ml-sm q-pb-none">Delete Provisions:</p>
      <q-chip v-for="provision in provisions" :key="provision.id"
      @remove="deleteProvision(provision)"
        removable
        v-model="data_provisions[provision.id]"
        color="grey"
        dense
        text-color="black"
        :label="provision.title"
      />
    </div>
    <div class="full-width  text-right q-mt-md">
      <q-btn label="CANCEL" @click="reload" type="button" color="accent" class="q-mr-sm"/>
      <q-btn label="SUBMIT" type="submit" color="primary"/>
    </div>
  </q-form>
  </div>
</template>
<script>
export default {
  name: 'EditTreatyWidget',
  props: ['name', 'description', 'avatarUrl', 'id', 'reload', 'provisions'],
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
      confirm: false,
      provisionsToDelete: [],
      data_provisions: [],
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
    deleteProvision (provision) {
      this.provisionsToDelete.push(provision.id)
    },
    handleInput (value) {
      this.$emit('msgChange', value)
    },
    deleteProvisions: async function () {
      let q = null
      for (let i = 0; i < this.provisionsToDelete.length; i++) {
        q = `${process.env.api}/treaty-provisions/${this.provisionsToDelete[0]}/provision-likes`
        await this.$axios.delete(q)
        q = `${process.env.api}/treaty-provisions/${this.provisionsToDelete[0]}/provision-comments`
        await this.$axios.delete(q)
        q = `${process.env.api}/treaty-provisions/${this.provisionsToDelete[0]}`
        console.log(q)
        await this.$axios.delete(q)
      }
    },
    postForm: async function (e) {
      this.deleteProvisions()
      const payload = {
        name: this.data_name,
        description: this.data_description,
        avatar_url: this.data_avatar_url,
        id: this.id
      }
      const q = `${process.env.api}/treaties/${this.id}`
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
