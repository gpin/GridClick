import GridClick.BoardModel;
import GridClick.BoardSummary;
import GridClick.CellButton;
import GridClick.CellEvent;
import GridClick.CellState;

import Resources.BoardList;
import Resources.Images;
import Resources.TxtLevels5;

import mx.containers.GridItem;
import mx.containers.GridRow;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.controls.Label;
import mx.core.Container;

protected var version_:String = "0.4.9";
protected var solution_:BoardModel;
protected var model_:BoardModel;
protected var row_summaries_:Array;
protected var col_summaries_:Array;
protected var cells_:Array;
protected var edit_mode_:Boolean = false;

public function initUserSavedStatus() : void
{
	// TODO: load user saved data (curent model, played boards, score...)
	// check if a game was started to continue -> in case, activate "continue" button
}

protected function onAppInit() : void
{
	// wire up resources
	status_.text = "GridClick Version " + version_ + " (c) 2011 by Guido Pinkas";
	menu_logo_.source = Resources.Images.Logo;
	play_logo_.source = Resources.Images.Logo;
	
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
	item.setStyle("verticalAlign", "bottom");
	item.setStyle("horizontalAlign", "center");
	return item;
}

protected function createRowSummaryItem() : GridItem
{
	var item:GridItem = new GridItem();
	item.addChild(new HBox());
	item.setStyle("verticalAlign", "middle");
	item.setStyle("horizontalAlign", "right");
	return item;
}

protected function createCellItem(x:int, y:int) : GridItem
{
	var item:GridItem = new GridItem();
	item.addChild(new CellButton(x, y));
	return item;
}

protected function createSummaryLabel(chunk:String, label_state:int = 0) : Label
{
	var label:Label = new Label();
	label.text = chunk.length.toString();
	label.setStyle("fontWeight", "bold");
	switch(label_state)
	{
	case 1: // ok
		label.enabled = false;
		break;
	case 2: // complete
		label.setStyle("color", "#00FF00");
		label.enabled = true;
	default: // fail
		label.enabled = true;
		break;
	}
	return label;
}

protected function getLabelState(marker:Array, index:int, complete:Boolean) : int
{
	if (complete)
	{
		return 2; // complete
	}
	else
	{
		if (marker && marker[index])
		{
			return 1; // ok
		}
	}
	return 0; // fail
	
}

protected function updateColSummary(x:int, info:Array, marker:Array = null, complete:Boolean = false) : void
{
	var container:GridItem = col_summaries_[x];
	var box:Container = Container(container.getChildAt(0));
	box.removeAllChildren();
	if (info.length>0)
	{
		for (var index:int = 0 ; index<info.length; index++)
		{
			box.addChild(createSummaryLabel(info[index], getLabelState(marker, index, complete)));
		}
	}
	else
	{
		box.addChild(createSummaryLabel(""));
	}
}

protected function updateRowSummary(y:int, info:Array, marker:Array = null, complete:Boolean = false) : void
{
	var container:GridItem = row_summaries_[y];
	var box:Container = Container(container.getChildAt(0));
	box.removeAllChildren();
	if (info.length>0)
	{
		for (var index:int = 0 ; index<info.length; index++)
		{
			box.addChild(createSummaryLabel(info[index], getLabelState(marker, index, complete)));
		}
	}
	else
	{
		box.addChild(createSummaryLabel(""));
	}
}

public function onCellClick(event:CellEvent) : void
{
	var x:int = event.col_index;
	var y:int = event.row_index;
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
	
	if (edit_mode_)
	{
		updateColSummary(x, model_.getColSummary(x));
		updateRowSummary(y, model_.getRowSummary(y));
	}
	else
	{
		var m_sum:Array;
		var s_sum:Array;
		var complete:Boolean;
		var marker:Array;
		
		// update col summary
		s_sum = solution_.getColSummary(x);
		m_sum = model_.getColSummary(x);
		complete = BoardSummary.equals(s_sum, m_sum);
		marker = null;
		if (!complete && m_sum.length>0)
		{
			marker = BoardSummary.getComparison(s_sum, m_sum);
		}
		updateColSummary(x, s_sum, marker, complete);
		
		// update row summary
		s_sum = solution_.getRowSummary(y);
		m_sum = model_.getRowSummary(y);
		complete = BoardSummary.equals(s_sum, m_sum);
		marker = null;
		if (!complete && m_sum.length>0)
		{
			marker = BoardSummary.getComparison(s_sum, m_sum);
		}
		updateRowSummary(y, s_sum, marker, complete);
		
		// check game complete
		checkGameComplete();
	}

//	Alert.show("Test: " + model_.getRowSummary(y).join(","));
//	Alert.show("You have clicked on: " + event.col_index + ":" + event.row_index);
}

protected function checkGameComplete() : void
{
	if (model_.equals(solution_))
	{
		Alert.show("GESCHAFFT!", "GEWONNEN");
	}
}

protected function updateGameViewSummaries(model:BoardModel) : void
{
	var x:int;
	var y:int;
	
	for (x=0; x<model.width; x++)
	{
		updateColSummary(x, model.getColSummary(x));
	}
	for (y=0; y<model.height; y++)
	{
		updateRowSummary(y, model.getRowSummary(y));
	}
}

protected function updateGameView(model:BoardModel) : void
{
	var x:int;
	var y:int;
	var state:int;
	
	for (y=0; y<model.height; y++)
	{
		for (x=0; x<model.width; x++)
		{
			state = model.getCell(x, y);
			CellButton(Container(cells_[y*model.width + x]).getChildAt(0)).State = state;
		}
	}
}

protected function createGameLayout(size:int) : void
{
	var col_index:int;
	var row_index:int;
	var cell_index:int;
	
	// clear the grid
	col_summaries_ = new Array();
	row_summaries_ = new Array();
	cells_ = new Array();
	grid_.removeAllChildren();
	
	// add top row (col summary display)
	var top_row:GridRow = new GridRow();
	
	var topleft_item:GridItem = new GridItem();
	top_row.addChild(topleft_item);
	
	for (col_index=0; col_index<size; col_index++)
	{
		col_summaries_[col_index] = createColSummaryItem();
		top_row.addChild(col_summaries_[col_index]);
	}
	
	grid_.addChild(top_row);
	
	// add other rows
	cell_index = 0;
	for (row_index=0; row_index<size; row_index++)
	{
		var item_row:GridRow = new GridRow();
		row_summaries_[row_index] = createRowSummaryItem();
		item_row.addChild(row_summaries_[row_index]);
		
		for (col_index=0; col_index<size; col_index++)
		{
			cells_[cell_index] = createCellItem(col_index, row_index);
			item_row.addChild(cells_[cell_index]);
			cell_index++;
		}

		grid_.addChild(item_row);
	} 
}

public function startNewGame(size:int) : void
{
	// init board models (solution and current)
	createBoard(size);
	
	if (!edit_mode_)
	{
		// load new game object (solution)
		var board_list:BoardList;
		switch(size)
		{
		case 5:
			board_list = new Resources.TxtLevels5();
			break;
		}
		
		var boards:Array = board_list.getBoards();
		var index:int = Math.round(Math.random() * (boards.length-1));
		solution_.importString(boards[index]);
	}
	
	// init view state (grid, timer, ec.)
	createGameLayout(size);
	if (edit_mode_)
	{
		updateGameViewSummaries(model_);
	}
	else
	{
		updateGameViewSummaries(solution_);
	}
	
	// TODO: start game timer

	// activate "Continue" button
	menu_continue_.enabled = true;
	
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
	// fill current model text representation into view-field
	model_source_.text = model_.exportString();
	
	// switch to view model state
	states_.selectedChild = view_model_state_;
}

public function onClearClick() : void
{
	// clear the current board model and update view
	model_.clear();
	updateGameView(model_);
	if (edit_mode_)
	{
		updateGameViewSummaries(model_);
	}
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



