<template>
  <div>
    <q-expansion-item icon="comment" :label="'Comments ' + commentCount" class="bg-grey-4">
      <div class="q-pa-md full-width">
        <q-form @submit="postComment">
          <q-input filled type="textarea" autogrow placeholder="Type comment here" v-model="newComment" :key="entityId" />
          <div class="row">
            <q-space />
            <q-btn type="submit" color="primary q-mt-lg">submit</q-btn>
          </div>
        </q-form>
      </div>
      <q-list>
        <q-separator spaced />
        <div v-if="!comments.length" class="text-center q-pa-lg">no comments</div>
        <q-item style="border-bottom:1px solid rgba(0, 0, 0, 0.12)" class="q-pa-lg q-ma-sm" v-for="comment in comments" :key="comment.id">
          <q-item-section top avatar>
            <q-avatar size="50px" class="q-mr-md">
              <q-img rounded class="avatar" :src="comment.creator.avatar_url"></q-img>
            </q-avatar>
          </q-item-section>
          <q-item-section>
            <q-item-label>{{ comment.creator.name }} says:</q-item-label>
            <q-item-label caption lines="10">{{ comment.text }}</q-item-label>
            <q-item-label>
              <q-badge outline class="q-mt-sm" color="secondary" :label="comment.create_date" />
            </q-item-label>
          </q-item-section>
        </q-item>
        <q-btn @click="showMore" v-if="this.currentPointer + this.limit <= this.commentCount" class="full-width text-center">show more</q-btn>
      </q-list>
    </q-expansion-item>
  </div>
</template>
<script>
export default {
  name: 'CommentsWidget',
  methods: {
    getComments: async function () {
      const q = `http://localhost:3000/${this.entityType}-comments/?filter[skip]=${this.currentPointer}&filter[limit]=${this.limit}&filter[where][${this.entityType}_id]=${this.entityId}&filter[include][][relation]=creator&filter[order]=create_date%20DESC`
      const comments = await this.$axios.get(q)
      this.comments = comments.data
    },
    showMore: async function () {
      this.currentPointer = this.currentPointer + this.limit
      const q = `http://localhost:3000/${this.entityType}-comments/?filter[skip]=${this.currentPointer}&filter[limit]=${this.limit}&filter[where][${this.entityType}_id]=${this.entityId}&filter[include][][relation]=creator&filter[order]=create_date%20DESC`
      const comments = await this.$axios.get(q)
      this.comments = this.comments.concat(comments.data)
    },
    getCommentCount: async function () {
      const q = `http://localhost:3000/${this.entityType}-comments/count?[where][${this.entityType}_id]=${this.entityId}`
      const res = await this.$axios.get(q)
      this.commentCount = res.data.count
    },
    postComment: async function () {
      const q = `http://localhost:3000/${this.entityType}-comments`
      const payload = {
        creator_user_id: this.$store.state.user.uid,
        text: this.newComment
      }
      payload[this.entityType + '_id'] = this.entityId
      await this.$axios.post(q, payload, { headers: { Accept: 'application/json' } })
      this.newComment = ''
      this.getComments()
    }
  },
  mounted () {
    this.getComments()
    this.getCommentCount()
  },
  data () {
    return {
      comments: [],
      newComment: '',
      currentPointer: 0,
      limit: 5,
      commentCount: ''
    }
  },
  props: {
    entityId: {
      type: Number,
      required: true
    },
    entityType: {
      type: String,
      required: true
    }
  }
}

</script>
