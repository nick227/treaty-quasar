<template>
  <q-page padding class="river-width">
    <div class="self-center">
      <q-card>
        <q-tabs v-model="tab" dense class="text-grey" active-color="primary" indicator-color="primary" align="justify" narrow-indicator>
          <q-tab name="achievements" label="achievements" />
          <q-tab name="users" label="Users" />
        </q-tabs>
        <q-separator />
        <q-tab-panels v-model="tab" animated>
          <q-tab-panel name="achievements">
            <AchievementAdminComponent />
          </q-tab-panel>
          <q-tab-panel name="users">
            <div class="text-h6">Users</div>
            Under Development
          </q-tab-panel>
        </q-tab-panels>
      </q-card>
    </div>
  </q-page>
</template>
<script>
import AchievementAdminComponent from 'components/admin/AchievementAdminComponent.vue'
export default {
  meta () {
    return {}
  },
  name: 'AdminPage',
  components: { AchievementAdminComponent },
  data () {
    return {
      tab: 'achievements'
    }
  }
}
</script>
