import GridClick.BoardModel;
import GridClick.CellButton;
import GridClick.CellEvent;
import GridClick.CellState;

import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.VBox;

protected var solution_:BoardModel;
protected var model_:BoardModel;

public function initUserSavedStatus() : void
{
	// TODO: load user saved data (curent model, played boards, score...)
	// check if a game was started to continue -> in case, activate "continue" button
}

protected function onAppInit() : void
{
	// add event listeners
	grid_.addEventListener(CellEvent.CLICK, onCellClick);
}

/*
 * -------- MAIN MENU STATE --------
 *
 */
public function onHelpClick() : void
{
	// switch to help state
	states_.selectedChild = help_state_;
}

protected function createBoard(size:int) : void
{
	solution_ = new BoardModel(size, size);
	model_ = new BoardModel(size, size);
}

protected function createColSummaryItem() : GridItem
{
	var item:GridItem = new GridItem();
	item.addChild(new VBox());
	return item;
}

protected function createRowSummaryItem() : GridItem
{
	var item:GridItem = new GridItem();
	item.addChild(new HBox());
	return item;
}

protected function createCellItem(x:int, y:int) : GridItem
{
	var item:GridItem = new GridItem();
	item.addChild(new CellButton(x, y));
	return item;
}

public function onCellClick(event:CellEvent) : void
{
	var x:int = event.col_index;
	var y:int = event.row_index
	var state:int = model_.getCell(x, y);
	
	switch(state)
	{
	case CellState.LOCKED:
		// do not modify locked cells
		break;
	case CellState.ON:
		model_.setCell(x, y, CellState.OFF);
		event.button.State = CellState.OFF;
		break;
	default: // EMPTY OR OFF
		model_.setCell(x, y, CellState.ON);
		event.button.State = CellState.ON;
		break;
	}
//	Alert.show("You have clicked on: " + event.col_index + ":" + event.row_index);
}

protected function createGameLayout(size:int) : void
{
	var col_index:int;
	var row_index:int;
	
	// clear the grid
	grid_.removeAllChildren();
	
	// add top row (col summary display)
	var top_row:GridRow = new GridRow();
	
	var topleft_item:GridItem = new GridItem();
	top_row.addChild(topleft_item);
	
	for (col_index=0; col_index<size; col_index++)
	{
		top_row.addChild(createColSummaryItem());
	}
	
	grid_.addChild(top_row);
	
	// add other rows
	for (row_index=0; row_index<size; row_index++)
	{
		var item_row:GridRow = new GridRow();
		item_row.addChild(createRowSummaryItem());
		
		for (col_index=0; col_index<size; col_index++)
		{
			item_row.addChild(createCellItem(col_index, row_index));
		}

		grid_.addChild(item_row);
	} 
}

public function startNewGame(size:int, edit_mode:Boolean = true) : void
{
	// init board models (solution and current)
	createBoard(size);
	
	if (!edit_mode)
	{
		// TODO: load new game object (solution)
	}
	
	// init view state (grid, timer, ec.)
	createGameLayout(size);
	
	// TODO: start game timer

	// show play state
	states_.selectedChild = play_state_;
}

/*
 * -------- PLAY GAME STATE --------
 *
 */

public function continueGame() : void
{
	// switch to play state
	states_.selectedChild = play_state_;
}

public function exitGame() : void
{
	// return to menu state
	states_.selectedChild = menu_state_;	
}

public function onViewModelClick() : void
{
	// TODO: fill current model text representation into view-field
	
	// switch to view model state
	states_.selectedChild = view_model_state_;
}

public function onClearClick() : void
{
	// TODO: clear the current board model and update view
}

/*
 * -------- HELP STATE --------
 *
 */
 
public function onHelpCloseClick() : void
{
	// return to menu state
	states_.selectedChild = menu_state_;	
}

/*
 * -------- VIEW MODEL STATE --------
 *
 */
 
public function onViewModelCloseClick() : void
{
	// return to play state
	states_.selectedChild = play_state_;	
}



