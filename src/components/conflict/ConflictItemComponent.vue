<template>
  <div class="">
  <q-item>
    <q-item-section>
      <div class="row full-width">
        <div class="col col-2">
          <div class="text-center q-pa-sm">{{ creator.name }}</div>
          <div class="text-center"><q-avatar size="100px" round class="q-mr-sm text-center q-mb-lg"><img class="" :src="creator.avatar_url" /></q-avatar></div>
        </div>
        <div class="col q-pt-lg q-mt-lg"><h6 class="q-pa-none">{{ title }}</h6><p class="q-pa-none">{{ description }}</p></div>
      </div>
    </q-item-section>
    <!-- user equals org a -->
    <q-item-section v-if="userOrganizationId == orgAid" side style="text-center">
      <div class="text-center q-pa-sm">{{ orgAname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      readonly=false
      :organizationId="orgAid" />
      <div class="text-center q-pa-sm">{{ orgBname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      readonly=true
      :organizationId="orgBid" />
    </q-item-section>
    <!-- end equals org a -->
    <!-- user equals org b -->
    <q-item-section v-if="userOrganizationId == orgBid" side style="text-center">
      <div class="text-center q-pa-sm">{{ orgAname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      readonly=true
      :organizationId="orgAid" />
      <div class="text-center q-pa-sm">{{ orgBname }}</div>
      <LikeButtons
      :entityType='entityType'
      :entityId="entityId"
      readonly=false
      :organizationId="orgBid" />
    </q-item-section>
    <!-- end equals org b -->
    </q-item>
    <CommentsWidget
          :entityId="entityId"
          :entityType="entityType"
          :userOrganizationId="userOrganizationId"
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
    creator: {
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
