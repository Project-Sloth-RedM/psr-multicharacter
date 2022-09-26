<script lang="ts">
	import {getContext, setContext} from 'svelte';

	export let bind = null;
</script>

<select bind:value={bind} name="gender">
	<option class="op" value="Male" selected>Male</option>
	<option class="op" value="Female">Female</option>
</select>

<style>
	select,
	option {
		background: url('../img/bg.png');
		border: none;
		outline-width: 0;
		display: flex;
		text-align: center;
		color: white;
		font-size: 1.8vw;
		width: 25vw;
		background-repeat: no-repeat;
		background-size: cover;
	}
	.op {
		background-color: #1b191a;
	}
</style>
