<template>
  <div class="full-width q-mb-lg">
    <q-card class="q-pb-lg">
      <div class="bg-grey full-width" style="height:10px;"></div>
      <q-card-section  class="q-pb-md text-center">
        <div class=""><router-link :to="'profile/'+item.creator.id">{{ item.creator.name }}</router-link></div>
        <q-avatar round size="40px" class=""><img :src="item.creator.avatar_url" /></q-avatar>
      </q-card-section>
      <q-card-section side class="q-pa-none text-center">
        <div class="q-pb-sm" v-html="readyMessage"></div>
        <div class="text-center full-width">{{ readyDate }}</div>
        <div v-if="typeof item.entity_id === 'number'" class="text-center full-width"><router-link :to="'/'+item.entity_type+'/'+item.entity_id">original post</router-link></div>
        <div class="q-pa-sm">
          <EmotionPickerWidget :emotions="item.emotions" :activityId="item.id" />
          <q-icon name="delete" @click="promptDelete" v-if="$errorHandler.isLoggedInUser(item.creator_user_id)" color="primary" size="20px" clickable class="cursor-pointer float-right q-mt-sm" />
        </div>
      </q-card-section>
    </q-card>
    <CommentsWidget
          :entityId="item.id"
          entityType="activity"
    ></CommentsWidget>
  <q-dialog v-model="confirmDelete" persistent>
      <q-card>
        <q-card-section class="row items-center">
          <q-avatar icon="check" color="primary" text-color="white" />
          <span class="q-ml-sm">Permanently delete this?</span>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Cancel" color="primary" v-close-popup />
          <q-btn flat label="DELETE FOREVER" @click="deleteItem" color="primary" />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>
<script>
import EmotionPickerWidget from 'components/widgets/EmotionPickerWidget.vue'
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import TextToolsMixin from 'components/mixins/TextToolsMixin.vue'
import DateToolsMixin from 'components/mixins/DateToolsMixin.vue'
export default {
  name: 'ActivityCardItem',
  mixins: [TextToolsMixin, DateToolsMixin],
  components: { CommentsWidget, EmotionPickerWidget },
  props: ['item', 'reload', 'entityId', 'entityType'],
  data () {
    return {
      confirmDelete: false
    }
  },
  computed: {
    readyDate: function () {
      const d = this.item.create_date
      return this.timeSince(d)
    },
    readyMessage: function () {
      return this.checkStr(this.item.message)
    }
  },
  methods: {
    deleteItem: async function () {
      this.confirmDelete = false
      const self = this
      const endpoints = ['activity-comments', 'activity-emotions', '']
      endpoints.forEach(function (endpoint, i) {
        console.log(i + 1, endpoints.length, i + 1 < endpoints.length)
        self.deleteQuery(endpoint, i + 1 === endpoints.length)
      })
    },
    deleteQuery: async function (endpoint, done) {
      const q = `${process.env.api}/activities/${this.item.id}/${endpoint}`
      await this.$axios.delete(q).then(() => {
        if (done) {
          this.reload()
          this.$q.notify({
            type: 'positive',
            message: 'Item deleted'
          })
        }
      }).catch((err) => {
        this.$q.notify({
          type: 'negative',
          message: 'Error deleting: ' + err
        })
      })
    },
    promptDelete: function () {
      this.confirmDelete = true
    }
  }
}
</script>
