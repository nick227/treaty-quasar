<template>
  <div>
      <q-btn class="full-width" color="accent" label="Add New" @click="openForm" />
      <q-dialog v-model="prompt" persistent>
      <q-card style="min-width: 350px">
        <q-card-section color="secondary">
          <div class="text-h6">Add {{ organizationName }} {{ entityType }}</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input required dense v-model="title" placeholder="title" autofocus />
          <q-input required dense v-model="description" placeholder="description" autogrow />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="CANCEL" @click="clearForm" v-close-popup />
          <q-btn flat label="SUBMIT" @click="submitForm" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>
<script>
import { ErrorHelper } from 'components/mixins/ErrorHelper.js'
export default {
  name: 'AddConflictItem',
  data () {
    return {
      prompt: false,
      title: '',
      description: ''
    }
  },
  mixins: [ErrorHelper],
  mounted () {},
  props: ['entityType', 'conflictId', 'organizationId', 'fn', 'organizationName', 'userOrganizationId'],
  methods: {
    openForm: function () {
      if (!this.isValid('organization', this.userOrganizationId)) {
        return false
      }
      this.prompt = true
    },
    clearForm: function () {
      this.title = ''
      this.description = ''
    },
    submitForm: async function () {
      const q = `${process.env.api}/${this.entityType.toLowerCase()}s`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        creator_organization_id: this.userOrganizationId,
        title: this.title,
        description: this.description,
        organization_id: this.organizationId,
        conflict_id: this.conflictId
      }
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.clearForm()
      this.fn()
    }
  }
}
</script>
