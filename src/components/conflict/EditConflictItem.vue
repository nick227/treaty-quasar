<template>
  <div>
    <q-card style="min-width: 350px">
      <q-card-section color="secondary">
        <div class="text-h6 capitalize">Edit {{ entityType }}-{{ editId }}</div>
      </q-card-section>

      <q-card-section class="q-pt-none">
        <q-input autogrow required dense maxlength="100" v-model="data_editTitle" :value="editTitle" label="Title" />
      </q-card-section>

      <q-card-actions align="right" class="text-primary">
        <q-btn flat label="SUBMIT" @click="submitForm" v-close-popup />
      </q-card-actions>
    </q-card>
  </div>
</template>
<script>
export default {
  meta () {
    return {}
  },
  name: 'EditConflictItem',
  props: ['editId', 'entityType', 'editTitle', 'reload'],
  data () {
    return {
      data_editTitle: this.editTitle
    }
  },
  methods: {
    submitForm: async function () {
      const payload = {
        title: this.data_editTitle
      }
      const q = `${process.env.api}/${this.entityType}s/${this.editId}`
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
  },
  mounted () {}
}
</script>
