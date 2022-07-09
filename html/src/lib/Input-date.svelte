<script lang="ts">
	export let date = '';
</script>

<main>
	<input bind:value={date} type="date" name="date" id="d" />
</main>

<style>
	input[type='date']::-webkit-inner-spin-button,
	input[type='date']::-webkit-calendar-picker-indicator {
		display: none;
		-webkit-appearance: none;
	}
	input {
		background: url('../img/bg.png');
		border: none;
		outline-width: 0;
		text-align: center;
		color: white;
		font-size: 1.8vw;
		width: 25vw;
		background-repeat: no-repeat;
		background-size: cover;
	}
</style>
