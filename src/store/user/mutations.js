export const updateUid = (state, uid) => {
  state.uid = uid
}
export const updateAvatar = (state, avatarUrl) => {
  state.avatarUrl = avatarUrl
}
export default function () {
  return {
    uid: true,
    avatarUrl: true,
    name: null,
    organizations: [],
    location: null
  }
}
