<template>
  <div>
    <div class="row q-mb-sm">
      <div class="col col-1 text-center">
        <h4 class="border text-center q-pa-sm bg-blue-grey-1">{{ index + 1 }}</h4>
      </div>
      <div class="col text-left q-pl-md">
        <h6 class="q-pa-none">{{ title }} <q-icon v-if="isUser" name="edit" class="cursor-pointer" clickable v-ripple size="13px" />
          <q-popup-edit v-model="title" buttons :validate="edit">
            <q-input v-model="title" :validate="edit" auto-save label-set="Save" dense autofocus counter />
          </q-popup-edit>
        </h6>
        <p class="q-pa-none">{{ description }} <q-icon v-if="isUser" name="edit" class="cursor-pointer" clickable v-ripple size="13px" />
          <q-popup-edit v-model="description" buttons :validate="edit">
            <q-input v-model="description" auto-save label-set="Save" dense autofocus counter />
          </q-popup-edit>
        </p>
      </div>
      <div class="col col-1 q-pt-sm">
        <LikeButtons
              class="float-right"
              entityType='provision'
              :entityId="provision.id"
              :organizationId="userOrganizationId" />
      </div>
    </div>
    <CommentsWidget
                :entityId="provision.id"
                entityType="provision"
                :userOrganizationId="userOrganizationId"
              ></CommentsWidget>
  </div>
</template>
<script>
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import LikeButtons from 'components/widgets/LikeButtonsWidget.vue'
export default {
  name: 'TreatyProvisionComponent',
  props: ['provision', 'index', 'userOrganizationId', 'creatorId'],
  components: { LikeButtons, CommentsWidget },
  data () {
    return {
      title: this.provision.title,
      description: this.provision.description,
      id: this.provision.id,
      isUser: this.$errorHandler.isLoggedInUser(this.creatorId)
    }
  },
  methods: {
    edit: async function (key) {
      const q = `${process.env.api}/treaty-provisions/${this.id}`
      const payload = {
        title: this.title,
        description: this.description
      }
      await this.$axios.patch(q, payload)
        .then((res) => {
          this.$q.notify({
            type: 'positive',
            message: 'Update Success'
          })
        })
        .catch((err) => {
          this.$q.notify({
            type: 'negative',
            message: 'Error Saving: ' + err
          })
        })
    }
  },
  mounted () {}
}
</script>
