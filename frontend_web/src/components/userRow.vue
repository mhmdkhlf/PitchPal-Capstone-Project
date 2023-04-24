<template>
  <div class="row">
    <div class="profile-picture">
      <img :src="imageSrc" alt="Profile Picture" v-if="imageSrc" />
      <img
        src="../assets/images/image.jpg"
        alt="Profile Picture"
        v-if="!imageSrc"
      />
    </div>
    <div class="user-info">
      <h2 class="user-name">{{ userName }}</h2>
      <p class="user-id">ID: {{ userId }}</p>
    </div>
    <div class="delete-button">
      <button class="btn-delete" @click="$emit('delete')">Delete</button>
    </div>
  </div>
</template>

<script>
export default {
  name: "userRaw",
  props: {
    userName: {
      type: String,
      required: true,
    },
    userId: {
      type: Number,
      required: true,
    },
    imageSrc: {
      type: String,
      required: true,
    },
  },
};
</script>

<style scoped>
.row {
  display: flex;
  align-items: center;
  justify-content: space-between;
  box-shadow: 0px 1px 2px rgba(0, 0, 0, 0.2);
  border: 1px solid #4caf50;
  border-radius: 5px;
  padding: 10px;
  margin-bottom: 10px;
}

.profile-picture {
  width: 30px;
  height: 30px;
  border-radius: 50%;
  overflow: hidden;
  margin-right: 15px;
}

.profile-picture img {
  width: 100%;
  height: auto;
  display: block;
}

.user-info {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.user-name {
  margin: 0;
  font-size: 16px;
  color: #4caf50;
}

.user-id {
  margin: 0;
  font-size: 14px;
  color: #4caf50;
}

.delete-button {
  margin-left: 15px;
}

.btn-delete {
  background-color: #ff4d4d;
  color: #fff;
  border: none;
  padding: 5px 8px;
  border-radius: 5px;
  cursor: pointer;
  margin-left: 5px;
}

.btn-delete:hover {
  background-color: #ff3333;
}
</style>
