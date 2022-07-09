import {writable} from 'svelte/store';
export const Locations = writable([
	{
		text: 'Last Location',
		value: 'last-location',
	},
	{
		text: 'Location #1',
		value: 'location-1',
	},
	{
		text: 'Location #2',
		value: 'location-2',
	},
	{
		text: 'Location #31111111111111',
		value: 'location-3',
	},
	{
		text: 'Location #4',
		value: 'location-4',
	},
]);
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
		addNewLocations: (locations) => {
			update((state) => {
				state = [...state, ...locations];
				return state;
			});

			// update((state) => {
			// 	state = [...state, locations];
			// 	return state;
			// });
		},
		reset: () => {
			set(defaultSpawn);
		},
	};
};
export default store();
