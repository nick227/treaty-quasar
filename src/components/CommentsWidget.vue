<template>
  <div>
      <q-expansion-item default-opened icon="comment" label="Comments" class="bg-cyan-1">
        <div class="q-pa-md full-width">
          <q-form @submit="onSubmit">
    <q-input
      filled
      type="textarea"
      autogrow
      placeholder="Type comment here"
    />
            <div class="row">
    <q-space />
    <q-btn type="submit" color="primary q-mt-lg">submit</q-btn>
  </div>
</q-form>
  </div>
  <q-list>
        <q-separator spaced  />
        <div v-if="!comments.length" class="text-center q-pa-lg">no comments</div>
    <q-item class="q-pl-lg q-ma-sm" v-for="comment in comments" :key="comment.id">
      <q-item-section top avatar>
      <q-avatar size="100px" class="q-mr-md"><q-img rounded class="avatar" :src="comment.creator.avatar_url"></q-img></q-avatar>
    </q-item-section>
    <q-item-section>
      <q-item-label>{{ comment.creator.name }} says:</q-item-label>
      <q-item-label caption lines="10">{{ comment.text }}</q-item-label>
      <q-item-label><q-badge outline class="q-mt-sm" color="secondary" :label="comment.create_date" /></q-item-label>
    </q-item-section>
    </q-item>
  </q-list>
</q-expansion-item>
  </div>
 </template>
<script>
export default {
  name: 'CommentsWidget',
  methods: {
    onSubmit (e) {
      e.preventDefault()
      console.log(this.$store.state.user.uid)
    }
  },
  async created () {
    const q = `http://localhost:3000/${this.type}-comments/?filter[where][${this.type}_id]=${this.entityId}&filter[include][][relation]=creator&filter[order]=create_date%20DESC`
    const comments = await this.$axios.get(q)
    this.comments = comments.data
  },
  data () {
    return {
      comments: []
    }
  },
  mounted () {},
  props: {
    entityId: {
      type: Number,
      required: true
    },
    type: {
      type: String,
      required: true
    }
  }
}

</script>
