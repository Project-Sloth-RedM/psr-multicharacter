import {writable} from 'svelte/store';
interface SpawnUIData {
	coords: Object;
	location: string;
	label: string;
}
const store = () => {
	const defaultSpawn = [
		{
			coords: {},
			location: 'lastlocation',
			label: 'Last Location',
		},
	];
	const {subscribe, set, update} = writable(defaultSpawn);
	return {
		subscribe,
		set,
		update,
		addNewLocations: (locations, newplayer?) => {
			update((state) => {
				if (newplayer) {
					state.splice(0, 1);
					state = [...locations];
					return state;
				} else {
					state = [...state, ...locations];
					return state;
				}
			});
		},
		reset: () => {
			set(defaultSpawn);
		},
	};
};
export default store();
