<template>
  <div>
    <div class="row q-mb-sm">
      <div class="col text-center">
        <h4 class="border text-center q-pa-sm bg-blue-grey-1">{{ index + 1 }}</h4>
      </div>
      <div class="col col-10 text-left q-pl-md">
        <h6 class="q-pa-none">{{ provision.title }}</h6>
        <p class="q-pa-none">{{ provision.description }}</p>
      </div>
      <div class="col text-center q-pt-sm">
        <LikeButtons
              :key="likeKey"
              entityType='provision'
              :entityId="provision.id"
              :organizationId="userOrganizationId" />
      </div>
    </div>
    <CommentsWidget
                :entityId="provision.id"
                entityType="provision"
              ></CommentsWidget>
  </div>
</template>
<script>
import CommentsWidget from 'components/widgets/CommentsWidget.vue'
import LikeButtons from 'components/widgets/LikeButtonsWidget.vue'
export default {
  name: 'TreatyProvisionComponent',
  props: ['provision', 'index'],
  components: { LikeButtons, CommentsWidget },
  data () {
    return {}
  },
  methods: {},
  mounted () {}
}
</script>
