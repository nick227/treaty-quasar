<template>
  <div class="activity-width">
    <div class="bg-blue-grey q-pa-md q-pt-lg">
      <h5 class="q-pa-none">Welcome to Concordant!</h5>
    </div>
    <h6 class="bg-grey q-pl-md">There are 5 ways to interact with the website</h6>
    <ul class="q-mt-lg">
      <li>
        <h5>1. Conflict</h5>
        <p>Each conflict is between two organizations that have problems to resolve. For example Liberals vs. Conservatives, Men vs. Women, Cats vs. Dogs. Discuss the problems and find solutions that most work for everyone.</p>
      </li>
      <li>
        <h5>2. Grievance</h5>
        <p>Identify the problems between organizations. Other users rate and comment by organization on the grievance. This is how to communicate what the real issues dividing organizations are and have the community help prioritize their significance.</p>
      </li>
      <li>
        <h5>3. Offer</h5>
        <p>After you see what the opposition's problems are make offers. These are potential concessions that your organization is willing to make to broker a successul treaty. The community rates and comments by organization. A successful treaty consists of equal offers that resolve the oppositon's grievances.</p>
      </li>
      <li>
        <h5>4. Debate</h5>
        <p>Area designated for discussing the relevant topics. We do ask that debators stay civil and reasonable. Although no subject is off-limits the subject must be related to conflict and threats or harrassment will be deleted and users may be banned at admin discretion. </p>
      </li>
      <li>
        <h5>5. Treaty</h5>
        <p>Treaties are a list of provisions that identify what each organization is willing to concede. A successful treaty is when a majority of voters from both organiztion vote YAY in agreement.</p>
      </li>
    </ul>
    <div class="q-mt-lg q-mb-sm">
      <h5 class="q-pa-none q-ma-none">Next steps...</h5>
      <q-separator />
    </div>
    <p class="q-mb-lg q-mt-lg">
      <router-link to="/login"><q-btn class="full-width" icon="login" color="primary" label="Step one is signup or login" /></router-link>
    </p>
    <h6>Join an organization</h6>
    <ul class="q-mb-lg">
      <li v-for="org in organizations" :key="org.id"><router-link :to="'/organization/'+org.id">{{ org.name }}: {{ org.description }}</router-link></li>
      <li class="q-pt-md"><router-link to="/organizations"><q-btn class="full-width" color="accent" label="View all organizations" /></router-link></li>
    </ul>
    <q-space />
    <h6>Review a conflict</h6>
    <ul class="q-mb-lg">
      <li v-for="conflict in conflicts" :key="conflict.id"><router-link :to="'/conflict/'+conflict.id">{{ conflict.name }}</router-link></li>
      <li class="q-pt-md"><router-link to="/conflicts"><q-btn class="full-width" color="accent" label="View all conflicts" /></router-link></li>
    </ul>
    <q-space />
    <h6>Create a treaty</h6>
    <ul class="q-mb-lg q-pb-lg">
      <li v-for="treaty in treaties" :key="treaty.id"><router-link :to="'/treaty/'+treaty.id">{{ treaty.name }}</router-link></li>
      <li class="q-pt-md"><router-link to="/treaties"><q-btn class="full-width" color="accent" label="View all treaties" /></router-link></li>
    </ul>
  </div>
</template>
<script>
export default {
  meta () {
    return {
      title: 'Welcome to Concordant.io'
    }
  },
  name: 'WelcomePage',
  components: {},
  data () {
    return {
      organizations: [],
      conflicts: [],
      treaties: [],
      limit: 5,
      pointer: 0
    }
  },
  methods: {
    getItems: function () {
      const entities = ['conflicts', 'organizations', 'treaties']
      entities.forEach(this.query)
    },
    query: async function (entityName) {
      const q = `${process.env.api}/${entityName}?filter[limit]=${this.limit}&filter[skip]=${this.pointer}`
      const res = await this.$axios.get(q)
      this[entityName] = res.data
    }
  },
  mounted () {
    this.getItems()
  }
}
</script>
