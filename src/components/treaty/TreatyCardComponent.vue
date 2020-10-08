<template>
  <q-card class="flex-break q-ma-lg">
    <router-link :to="'/treaty/'+treaty.id"><div :style="'background-image:url(' + treaty.avatar_url + ')'" class="card-image"></div></router-link>
    <q-card-section>
      <router-link :to="'conflict/'+treaty.conflict_id"><div class="ellipsis">{{ treaty.organization_a.name }} vs. {{ treaty.organization_b.name }}</div></router-link>
      <div class="text-h6 ellipsis">{{ treaty.name }}</div>
      <div class="text-caption">Created by: <router-link :to="'profile/'+treaty.creator_user_id">{{ treaty.creator_name }}</router-link></div>
      <div class="text-caption ellipsis">Organization: <router-link :to="'organization/'+treaty.creator_organization_id">{{ treaty.creator_organization_name }}</router-link></div>
      <div>{{ treaty.provisions.length }} Provisions</div>
    </q-card-section>
    <q-card-section>
      <router-link :to="'/treaty/'+treaty.id"><q-btn class="full-width" color="primary" label="Visit" /></router-link>
    </q-card-section>
    <q-card-section>
      <q-separator class="q-mt-sm q-mb-sm" />
      <div class="row">
        <div class="col">Yay: {{ treaty.yay_votes }} Nay: {{ treaty.nay_votes }}</div>
        <div class="col text-right">Rated {{ treaty.rating }}/5</div>
      </div>
    </q-card-section>
  </q-card>
</template>
<script>
export default {
  name: 'TreatyCardComponent',
  props: ['treaty'],
  components: {},
  data () {
    return {}
  },
  methods: {},
  mounted () {}
}
</script>
