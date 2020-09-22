<template>
  <div>
  <q-item>
    <q-item-section top>
      <q-item-label class="q-mb-sm"><q-badge color="grey">{{ organization }} {{ entityType }}</q-badge></q-item-label>
      <q-item-label><q-avatar size="40px" square class="q-mr-sm"><q-img rounded class="q-mt-none" :src="entity.creator.avatar_url"></q-img></q-avatar>{{ entity.creator.name }} writes:</q-item-label>
      <q-item-label><h6 class="q-pa-none">{{ entity.title }}</h6></q-item-label>
      <q-item-label caption class="q-pb-md">{{ entity.description }}</q-item-label>
    </q-item-section>
    <q-item-section side style="">
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      :organizationId="userOrganizationId" />
    </q-item-section>
    </q-item>
    <CommentsWidget
          :entityId="entityId"
          :entityType="entityType"
    ></CommentsWidget>
</div>
</template>
<script>
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import LikeButtons from 'components/widgets/LikeButtonsWidget.vue'
export default {
  name: 'ConflictComponent',
  components: { CommentsWidget, LikeButtons },
  data () {
    return {}
  },
  mounted () {},
  props: {
    entityId: {
      type: Number,
      required: true
    },
    entity: {
      type: Object,
      required: true
    },
    userOrganizationId: {
      type: Number,
      required: true
    },
    organizationId: {
      type: Number,
      required: true
    },
    organizationAvatarUrl: {
      type: String,
      required: true
    },
    title: {
      type: String,
      required: true
    },
    entityType: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    organization: {
      type: String,
      required: true
    },
    orgAname: {
      type: String,
      required: false
    },
    orgBname: {
      type: String,
      required: true
    },
    orgAid: {
      type: Number,
      required: false
    },
    orgBid: {
      type: Number,
      required: true
    }
  }
}
</script>
